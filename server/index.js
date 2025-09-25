const express = require("express")
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");

const app = express()
const PORT =  3000;
const DB = "mongodb+srv://mozi47agent:IwjFVODEKucekexZ@cluster0.bmitl5u.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

app.use(express.json())
app.use(authRouter)
mongoose
  .connect(DB)
  .then(() => {
    console.log("Mongoose Connected Successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT,"0.0.0.0",()=> {
    console.log("server Started")
})