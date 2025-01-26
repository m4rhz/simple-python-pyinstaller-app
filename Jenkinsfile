node {
    stage('Build') {
        docker.image('python:3.9-slim').inside {
            sh '''
                cd sources
                pip install -r requirements.txt
                python -m py_compile calc.py web_app.py
            '''
            stash(name: 'compiled-results', includes: 'sources/*.py*')
        }
    }
    
    stage('Test') {
        docker.image('qnib/pytest').inside {
            sh 'pytest sources/test_calc.py'
        }
    }
    
    stage('Manual Approval') {
        input message: 'Lanjutkan ke tahap Deploy?', ok: 'Proceed'
    }
    
    stage('Deploy') {
        // Railway deployment command
        sh 'railway up'
    }
}
