function handleMongooseError(res, e) {
  if (e.name === "ValidationError") {
    let errors = {};
    for (let field in e.errors) {
      errors[field] = e.errors[field].message;
    }
    return res.status(400).json(errors);
  }
  return res.status(500).json({ error: e.message });
}

module.exports = handleMongooseError;