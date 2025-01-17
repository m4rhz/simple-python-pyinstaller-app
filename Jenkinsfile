inode {
    // Define images with latest versions
    def pythonImage = 'python:3-alpine'
    def pytestImage = 'pytest:latest'
    def pyinstallerImage = 'cdrx/pyinstaller-linux:python3'

    stage('Clone') {
        git branch: 'main', url: 'https://github.com/m4rhz/simple-python-pyinstaller-app'
    }

    stage('Build') {
        docker.image(pythonImage).inside {
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
        }
    }

    stage('Test') {
        docker.image(pytestImage).inside {
            sh 'pytest --verbose --junit-xml=test-reports/results.xml sources/test_calc.py'
            junit 'test-reports/results.xml'
        }
    }

    stage('Deliver') {
        docker.image(pyinstallerImage).inside {
            sh 'python -m PyInstaller --onefile sources/add2vals.py'
        }
    }
}

