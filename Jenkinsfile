node {
    try {
        stage('Build') {
            docker.image('python:2-alpine').inside {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
                stash name: 'compiled-results', includes: 'sources/*.py*'
            }
        }

        stage('Test') {
            docker.image('qnib/pytest').inside {
                sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
            }
            junit 'test-reports/results.xml'
        }

        stage('Deliver') {
            def workspace = sh(script: 'pwd', returnStdout: true).trim()
            def volume = "${workspace}/sources:/src"
            def image = 'cdrx/pyinstaller-linux:python2'
            def buildDir = env.BUILD_ID

            dir(buildDir) {
                unstash 'compiled-results'

                // Ensure `add2vals.py` exists in the sources directory
                sh "ls -l ${workspace}/sources"

                // Run PyInstaller
                sh "docker run --rm -v ${volume} ${image} pyinstaller -F /src/add2vals.py"
            }

            // Archive the artifact
            archiveArtifacts artifacts: "${buildDir}/sources/dist/add2vals"

            // Clean up the build artifacts inside the container
            sh "docker run --rm -v ${volume} ${image} rm -rf /src/build /src/dist"
        }
    } catch (err) {
        currentBuild.result = 'UNSTABLE'
        throw err
    }
}
