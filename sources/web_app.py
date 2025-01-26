from flask import Flask, request, render_template
import calc
import os

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def calculator():
    result = None
    x = None
    y = None
    
    if request.method == 'POST':
        x = request.form.get('x', '')
        y = request.form.get('y', '')
        
        try:
            result = calc.add2(x, y)
        except Exception as e:
            result = f"Error: {str(e)}"
    
    return render_template('index.html', result=result, x=x, y=y)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8000)))
