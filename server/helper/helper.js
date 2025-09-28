function handleValidationError(res, e) {
  if (e.name === "ValidationError") {
    let errors = {};
    for (let field in e.errors) {
      errors[field] = e.errors[field].message;
    }
    return res.status(400).json(errors);
  }
  else if (e.name === "CastError") {
      return res.status(400).json({ message: "Wrong Credentials" });
    }
  return res.status(500).json({ error: e.message });
}

module.exports = handleValidationError;