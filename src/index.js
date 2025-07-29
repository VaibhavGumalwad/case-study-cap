const express = require('express');
const app = express();
const PORT = 80;

// Serve static files
app.use(express.static('public'));

const path = require('path');
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '/public/index.html'));
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
