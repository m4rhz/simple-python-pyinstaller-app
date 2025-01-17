node {
    // Definisikan images yang akan digunakan
    def pythonImage = 'python:3-alpine'
    def pytestImage = 'qnib/pytest'
    // def pyinstallerImage = 'cdrx/pyinstaller-linux:python3'
    
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
    docker.image('python:3.12-slim').inside {
        sh '''
        # Upgrade pip and install to a custom directory
        python -m pip install --upgrade pip --no-cache-dir
        python -m pip install pyinstaller --no-cache-dir --prefix /tmp/pip-packages

        # Add the custom path to PYTHONPATH
        export PYTHONPATH=/tmp/pip-packages/lib/python3.12/site-packages:$PYTHONPATH

        # Run PyInstaller
        python -m PyInstaller --onefile sources/add2vals.py
        '''
    }
}

}

