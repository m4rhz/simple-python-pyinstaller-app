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
            def volume = "$(pwd)/sources:/src"
            def image = 'cdrx/pyinstaller-linux:python2'
            def buildDir = env.BUILD_ID

            dir(buildDir) {
                unstash 'compiled-results'
                sh "docker run --rm -v ${volume} ${image} 'pyinstaller -F add2vals.py'"
            }

            archiveArtifacts artifacts: "${buildDir}/sources/dist/add2vals"

            sh "docker run --rm -v ${volume} ${image} 'rm -rf build dist'"
        }
    } catch (err) {
        currentBuild.result = 'UNSTABLE'
        throw err
    }
}
