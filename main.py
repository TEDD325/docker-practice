from fastapi import FastAPI, Form, Request
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.staticfiles import StaticFiles
import uvicorn

app = FastAPI()

# Mount the 'public' directory to serve static files
app.mount("/public", StaticFiles(directory="public"), name="public")

# Global variable to store the user goal
my_name = "It's DoHyung"
my_goal = None

@app.get("/", response_class=HTMLResponse)
async def read_root():
    html_content = f"""
    <html>
      <head>
        <link rel="stylesheet" href="/public/styles.css">
      </head>
      <body>
        <section>
          <h2>Introduction</h2>
          <h3>{my_name}</h3>
          <h3>My Today's goal is</h3>
          <h4>{my_goal}</h4>
        </section>
        <form action="/store-goal" method="POST">
          <div class="form-control">
            <label>Enter the goal</label>
            <input type="text" name="goal">
          </div>
          <button type="submit">Set Goal</button>
        </form>
      </body>
    </html>
    """
    return HTMLResponse(content=html_content, status_code=200)

@app.post("/store-goal")
async def store_goal(goal: str = Form(...)):
    global my_goal
    print(goal)  # Logs the entered goal to the console
    my_goal = goal
    return RedirectResponse(url="/", status_code=303)

if __name__ == "__main__":
    # Run the app on host 0.0.0.0 and port 80
    uvicorn.run(app, host="0.0.0.0", port=80)