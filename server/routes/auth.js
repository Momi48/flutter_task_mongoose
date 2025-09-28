const express = require("express")
const mongoose = require("mongoose")
const jwt = require("jsonwebtoken")
const User = require("../model/user.js")
const authRouter = express.Router()
const bcryptjs = require("bcrypt")
const handleMongooseError = require("../helper/helper.js")

authRouter.post("/api/create-user", async (req, res) => {
    try {
        const { name, email, age } = req.body

        const existingUser = await User.findOne({ email })
        console.log("existingUser", existingUser)
        if (existingUser) {
            return res
                .status(409)
                .json({ message: "User with same email already exists!" });
        }

        let user = new User({
            name, email, age
        })
        console.log("user")
        user = await user.save()
        return res.status(201).json(user)
    }
    catch (e) {

         handleMongooseError(res, e)
        res.status(500).json({ error: e.message })

    }
})


authRouter.get("/api/get-user", async (req, res) => {
    try {
        const { name } = req.query;

        let users = null;

        if (name) {

            users = await User.find({ name: new RegExp(name, "i") });
        } else {

            users = await User.find({});
        }



        return res.status(200).json(users);

    } catch (e) {
         handleMongooseError(res, e)

        res.status(500).json({ error: e.message });
    }
})





authRouter.get("/api/find-user/:id", async (req, res) => {
    try {
        const { id } = req.params.id;
        const user = await User.findById(id);
       console.log("user ",typeof id)
        if (!user) 
            return res.status(409)
            .json({ message: "No User found With that Specific ID" });
            
            return res.status(200).json(user);
} 
catch (e) {
         handleMongooseError(res, e)

       return res.status(500).json({ error: e.message });
    }
});

module.exports = authRouter