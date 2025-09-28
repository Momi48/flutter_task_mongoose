const mongoose = require("mongoose")


const userSchema = mongoose.Schema(
  {
    name: {
    required: true,
    type: String,
    trim: true,
    // minlength: 3,
    // maxlength: 20,
    validate: {
      validator: (value) => {
         return value.length > 3 && value.length <= 20
      },
      message: "Characters should be between 3 and 20",
    },
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },
  age: {
    required: true,
    type: Number,
    trim: true,
    validate: {
      validator: (value) => {
         return  value >= 18
      },
      message: "Age must be 18 ",
    },
  },
  // password: {
  //   required: true,
  //   type: String,
  //    validate: {
  //     validator:  (value) => {
  //       return value.length >= 6; 
  //     },
  //     message: "Password length must be greater than 6",
  //   },
  // },
   
 
},
{ timestamps: true }
)
const User = mongoose.model("User", userSchema);
module.exports = User;