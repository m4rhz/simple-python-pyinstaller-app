node {
    def buildFailed = false
    
    try {
        stage('Build') {
            docker.image('python:2-alpine').inside {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
                stash(name: 'compiled-results', includes: 'sources/*.py*')
            }
        }
        
        if (!buildFailed) {
            stage('Test') {
                docker.image('qnib/pytest').inside {
                    try {
                        sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
                    } finally {
                        junit 'test-reports/results.xml'
                    }
                }
            }
        }
        
        if (!buildFailed) {
            stage('Deliver') {
                def buildDir = "${env.WORKSPACE}/${env.BUILD_ID}"
                
                // Create build directory and unstash files
                dir(buildDir) {
                    unstash 'compiled-results'
                    
                    // Define the correct volume mapping
                    def volume = "${buildDir}/sources:/src"
                    def image = 'cdrx/pyinstaller-linux:python2'
                    
                    // Run pyinstaller
                    sh "docker run --rm -v ${volume} ${image} 'pyinstaller -F add2vals.py'"
                    
                    // Archive artifacts if successful
                    if (currentBuild.currentResult == 'SUCCESS') {
                        // Look for artifacts in the correct path
                        archiveArtifacts "sources/dist/add2vals"
                        
                        // Clean up
                        sh "docker run --rm -v ${volume} ${image} 'rm -rf build dist'"
                    }
                }
            }
        }
    } catch (Exception e) {
        buildFailed = true
        currentBuild.result = 'FAILURE'
        throw e
    }
}
