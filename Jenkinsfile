node {
    def buildFailed = false
    
    try {
        stage('Build') {
            docker.image('python:3.9-slim').inside('-u root') {
                sh 'pip install flask'
                sh 'ls -l sources'
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
            stage('Manual Approval') {
                input message: 'Lanjutkan ke tahap Deploy?', ok: 'Proceed'
            }
        }
        
        if (!buildFailed) {
            stage('Deploy') {
                dir("${env.WORKSPACE}/${env.BUILD_ID}") {
                    unstash 'compiled-results'
                    sh '''
                        echo 'FROM python:3.9-slim
                        WORKDIR /app
                        COPY ./sources/calc.py .
                        COPY ./sources/add2vals.py .
                        COPY ./sources/index.html .
                        COPY ./sources/web_app.py .
                        RUN pip install flask
                        EXPOSE 8000
                        CMD ["python", "web_app.py"]' > Dockerfile
                        docker build -t web-calculator .
                        docker run -d --name web-app -p 8000:8000 web-calculator
                        sleep 60
                        docker stop web-app
                        docker rm web-app
                    '''
                }
            }
        }
    } catch (Exception e) {
        buildFailed = true
        currentBuild.result = 'FAILURE'
        throw e
    }
}
