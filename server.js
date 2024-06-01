// server.js
const express = require('express');
const path = require('path');

const app = express();
const port = 7000;

// Serve the static files from the Svelte build directory
app.use(express.static(path.join(__dirname, 'svelte-app', 'public')));

// Catch-all route to serve the index.html file
app.get('*', (req, res) => {
    console.log(req.headers)
    res.sendFile(path.join(__dirname, 'svelte-app', 'public', 'index.html'));
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
