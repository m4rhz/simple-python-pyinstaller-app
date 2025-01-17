node {
    // Definisikan images yang akan digunakan
    def pythonImage = 'python:2-alpine'
    def pytestImage = 'qnib/pytest'
    def pyinstallerImage = 'cdrx/pyinstaller-linux:python2'
    
    stage('Clone') {
        // Langsung menggunakan git step
        git branch: 'master', 
            url: 'https://github.com/m4rhz/simple-python-pyinstaller-app'
    }
    
    stage('Build') {
        // Menggunakan docker.image().inside untuk menjalankan di container
        docker.image(pythonImage).inside {
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
        }
    }
    
    stage('Test') {
        // Jalankan test dalam container pytest
        docker.image(pytestImage).inside {
            try {
                sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            } finally {
                // Post actions diimplementasikan dengan try-finally
                junit 'test-reports/results.xml'
            }
        }
    } 

    stage('Deliver') {
        // Build executable dalam container pyinstaller
        docker.image(pyinstallerImage).inside {
            sh 'PyInstaller --onefile sources/add2vals.py'
            
            // Post actions diimplementasikan dengan if condition
            if (currentBuild.currentResult == 'SUCCESS') {
                archiveArtifacts artifacts: 'dist/add2vals', fingerprint: true
            }
        }
    }
}
