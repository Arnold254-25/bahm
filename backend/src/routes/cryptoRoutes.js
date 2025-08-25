const express = require('express');
const axios = require('axios');
const router = express.Router();

// Image proxy endpoint to bypass CORS issues
router.get('/crypto/image/:imagePath(*)', async (req, res) => {
  try {
    const { imagePath } = req.params;
    const imageUrl = `https://assets.coingecko.com/coins/images/${imagePath}`;
    
    // Fetch the image from CoinGecko
    const response = await axios.get(imageUrl, {
      responseType: 'arraybuffer'
    });

    // Set proper CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
    
    // Set appropriate content type based on the image
    const contentType = response.headers['content-type'] || 'image/png';
    res.setHeader('Content-Type', contentType);
    
    // Cache the image for better performance (1 day)
    res.setHeader('Cache-Control', 'public, max-age=86400');
    
    // Send the image data
    res.send(response.data);
  } catch (error) {
    console.error('Error proxying crypto image:', error);
    res.status(500).json({ error: 'Failed to fetch image' });
  }
});

// Crypto data endpoints
router.get('/crypto/markets', async (req, res) => {
  try {
    const { vs_currency = 'usd', per_page = 50, page = 1 } = req.query;
    const response = await axios.get(`https://api.coingecko.com/api/v3/coins/markets`, {
      params: {
        vs_currency,
        order: 'market_cap_desc',
        per_page,
        page,
        sparkline: false
      }
    });
    
    res.json(response.data);
  } catch (error) {
    console.error('Error fetching crypto markets:', error);
    res.status(500).json({ error: 'Failed to fetch cryptocurrency data' });
  }
});

router.get('/crypto/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const response = await axios.get(`https://api.coingecko.com/api/v3/coins/${id}`);
    res.json(response.data);
  } catch (error) {
    console.error('Error fetching crypto details:', error);
    res.status(500).json({ error: 'Failed to fetch cryptocurrency details' });
  }
});

module.exports = router;
