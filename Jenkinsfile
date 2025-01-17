node {
    // Similar to skipStagesAfterUnstable
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
                        // This is equivalent to post { always { ... } }
                        junit 'test-reports/results.xml'
                    }
                }
            }
        }
        
        if (!buildFailed) {
            stage('Deliver') {
                // Define environment variables
                def volume = "${pwd()}/sources:/src"
                def image = 'cdrx/pyinstaller-linux:python2'
                
                // Create directory with BUILD_ID and unstash files
                dir("${env.BUILD_ID}") {
                    unstash 'compiled-results'
                    
                    // Run pyinstaller in container
                    sh "docker run --rm -v ${volume} ${image} 'pyinstaller -F add2vals.py'"
                    
                    // Archive artifacts if successful
                    if (currentBuild.currentResult == 'SUCCESS') {
                        archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals"
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