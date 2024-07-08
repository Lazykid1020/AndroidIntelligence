const express = require('express');
const dotenv = require('dotenv');
const { GoogleGenerativeAI } = require('@google/generative-ai');
dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

// Initialize GoogleGenerativeAI with your API key
const genAI = new GoogleGenerativeAI(process.env.API_KEY);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Endpoint to solve an equation from the base64 image string
app.post('/solve-equation', async (req, res) => {
  try {
    const { imageBase64, mimeType, prompt } = req.body;
    //save image to file
    // const fs = require('fs');
    // const path = require('path');
    // const base64Data = imageBase64.replace(/^data:image\/png;base64,/, "");
    // const filename = path.join(__dirname, 'image.png');
    // fs.writeFileSync(filename, base64Data, 'base64')
    if (!imageBase64 || !mimeType) {
      return res.status(400).json({ error: 'Image base64 string and MIME type are required' });
    }

    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-pro' });

    const result = await model.generateContent([
      {
        inlineData: {
          data: imageBase64,
          mimeType: mimeType
        }
      },
      { text: prompt || "Solve the equation in the image and only give the result along with claculation steps used , make sure to not give text unless pyhsics is involved and each step is seperated by a new line character." },
    ]);

    res.json({ solution: result.response.text() });
  } catch (error) {
    console.error('Error solving equation:', error);
    res.status(500).json({ error: 'Failed to solve equation' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
