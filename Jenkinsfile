node {
    def buildFailed = false
    
    try {
        stage('Build') {
            docker.image('python:3.9-slim').inside {
                sh 'pip install -r sources/requirements.txt'
                sh 'python -m py_compile sources/calc.py sources/web_app.py'
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
            stage('Manual Approval') {
                input message: 'Lanjutkan ke tahap Deploy?', ok: 'Proceed'
            }
        }
        
        if (!buildFailed) {
            stage('Deploy') {
                def buildDir = "${env.WORKSPACE}/${env.BUILD_ID}"
                
                dir(buildDir) {
                    unstash 'compiled-results'
                    
                    docker.build('web-calculator', './sources')
                    
                    sh '''
                        docker run -d --name web-app -p 8000:8000 web-calculator
                        sleep 60
                        docker stop web-app
                        docker rm web-app
                    '''

                    archiveArtifacts 'sources/*.py'
                }
            }
        }
    } catch (Exception e) {
        buildFailed = true
        currentBuild.result = 'FAILURE'
        throw e
    }
}
