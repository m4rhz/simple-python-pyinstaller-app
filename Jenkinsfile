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
                        find ${WORKSPACE} -name Dockerfile
                        ls -la ${WORKSPACE}
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
