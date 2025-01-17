node {
    stage('Clone') {
        // Langsung menggunakan git step
        git branch: 'master', 
            url: 'https://github.com/m4rhz/simple-python-pyinstaller-app'
    }
    
    stage('Build') {
        // Menggunakan docker.image().inside untuk menjalankan di container
        docker.image('python:2-alpine').inside {
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
        }
    }
    
    stage('Test') {
        // Jalankan test dalam container pytest
        docker.image('qnib/pytest').inside {
            try {
                sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            } finally {
                // Post actions diimplementasikan dengan try-finally
                junit 'test-reports/results.xml'
            }
        }
    } 
    
    stage('Deliver') {
        // Build executable dalam container python dengan pyinstaller
        docker.image('python:3.9').inside {
            try {
                // Add verbose output for debugging
                sh '''
                    python --version
                    pip install pyinstaller
                    ls -la sources/
                    pyinstaller --onefile sources/add2vals.py
                    ls -la dist/
                '''
                
                // Post actions with error handling
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