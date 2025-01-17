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

    stage('Deploy') {
        docker.image('cdrx/pyinstaller-linux:python2').inside("--entrypoint=''") {
            try {
                sh 'python -m PyInstaller --onefile sources/add2vals.py'
            } catch (Exception e) {
                echo 'Error: ' + e.toString()
            } finally {
                success {
                    archiveArtifacts 'dist/add2vals'
                    sleep 60
                }
            }
        }
    }
}
