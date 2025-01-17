node {
    stage('Clone') {
        git branch: 'master', 
            url: 'https://github.com/m4rhz/simple-python-pyinstaller-app'
    }
    
    stage('Build') {
        docker.image('python:2-alpine').inside {
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
        }
    }
    
    stage('Test') {
        docker.image('qnib/pytest').inside {
            try {
                sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            } finally {
                junit 'test-reports/results.xml'
            }
        }
    } 
    
    stage('Deliver') {
        // Build executable dalam container python dengan pyinstaller
        docker.image('python:3.9').inside {
            try {
                sh '''
                    python --version
                    # Create directory for pip cache and set permissions
                    mkdir -p /tmp/pip-cache
                    chmod 777 /tmp/pip-cache
                    
                    # Install pyinstaller with specific cache directory
                    PIP_CACHE_DIR=/tmp/pip-cache pip install --user pyinstaller
                    
                    # Add local bin to PATH
                    export PATH=$PATH:$HOME/.local/bin
                    
                    ls -la sources/
                    pyinstaller --onefile sources/add2vals.py
                    ls -la dist/
                '''
                
                if (currentBuild.currentResult == 'SUCCESS') {
                    archiveArtifacts artifacts: 'dist/add2vals', fingerprint: true
                }
            } catch (Exception e) {
                echo "Error in Deliver stage: ${e.message}"
                currentBuild.result = 'FAILURE'
                throw e
            }
        }
    }
}