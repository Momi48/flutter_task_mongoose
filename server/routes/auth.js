const express = require("express");
const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");
const User = require("../model/user.js");
const authRouter = express.Router();
const bcryptjs = require("bcrypt");
const handleValidationError = require("../helper/helper.js");

authRouter.post("/api/create-user", async (req, res) => {
  try {
    const { name, email, age } = req.body;
   
    const existingUser = await User.findOne({ email });
    console.log("existingUser", existingUser);
    if (existingUser) {
      return res
        .status(409)
        .json({ message: "User with same email already exists!" });
    }

    let user = new User({
      name,
      email,
      age,
    });
    console.log("user");
    user = await user.save();
    return res.status(201).json(user);
  } catch (e) {
    handleValidationError(res, e);
  }
});

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
    handleValidationError(res, e);
  }
});

authRouter.get("/api/find-user/:id", async (req, res) => {
  try {
    const id = req.params.id;
    console.log("user ", id);

    const user = await User.findById(id);

    if (!user) {
      return res.status(409).json({ message: "No User found " });
    }
    return res.status(200).json(user);
  } catch (e) {
    handleValidationError(res, e);
  }
});
authRouter.put("/api/update-user/:id", async (req, res) => {
  try {
    const {name} = req.body
    const id = req.params.id;
    let user = await User.findByIdAndUpdate(id, {name}, {new: true});
    console.log("user is ",user)
    if (!user) {
      return res.status(409).json({ message: "No User found" });
    }
    return res.status(200).json(user);
  } catch (e) {
    handleValidationError(res, e);
  }
});

authRouter.delete("/api/delete-user/:id", async (req, res) => {
  try {
    const id = req.params.id;
    let user = await User.findByIdAndDelete(id);
    console.log("user is ",user)
    if (!user) {
      return res.status(409).json({ message: "No User found" });
    }
    return res.status(200).json({message: "user Deleted ",user});
  } catch (e) {
    handleValidationError(res, e);
  }
});
module.exports = authRouter;
