const express = require('express');
const {Pool} = require('pg');
const bcrypt = require('bcrypt');
const axios = require ('axios');
const app = express();
app.use(express.json());


const pool = new Pool({
    user:'your_username',
    host:'localhost',
    database:'Bahm',
    password:'your_password',
    port:5432,
});


//Signup endpoint

app.post ('/signup', async (req, res) => {
const {username,phone_number, email, password, user_type,id_number,passport_number, country_of_origin} = req.body;

try{
    //input validations

    if(!username || !phone_number || !password || !user_type){
        return res.status(400).json({error: 'Missing required fields'});
    }
if (user_type === 'citizen' && !id_number){
    return res.status(400).json({error: 'Kenyan ID number is required for citizens'});
}

    if(user_type === 'tourist' && !passport_number){
        return res.status(400).json({error: 'Passport number is required for tourists'});
    }

    //validate kenyan ID Format (8-9 digits)
    if(user_type === 'citizen' && !/^\d{8,9}$/.test(id_number)){
        return res.status(400).json({error: 'Invalid Kenyan ID number format (8-9 digits)'});
    }

    //validate passport number format (alphanumeric, 6-9 characters)
    if(user_type === 'tourist' && !/ ^[A-Za-z0-9]{6,12}$/.test(passport_number)){
        return res.status(400).json({error: 'Invalid passport number format'});
    }

    //hash password
    const password_hash = await bcrypt.hash(password, 10);

    //insert user 

    const result = await pool.query(
        `INSER INTO users(username, phone_number, email, password_hash, user_type, id_number, passport_number, country_of_origin)
        
        VALUES($1, $2, $3, $4, $5, $6, $7, $8) 
        RETURNING id, username,phone_number, user_type, is_verified`,
        [username, phone_number, email,password_hash, user_type,id_number, passport_number, country_of_origin]
    );

    //send OTP (example using Twilio replace with your SMS service)
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
        // await axios.post('https://api.twilio.com/2010-04-01/Accounts/your_account_sid/Messages.json', {
    //   From: 'your_twilio_number',
    //   To: phone_number,
    //   Body: `Your BAHM OTP is ${otp}`,
    // }, {
    //   auth: { username: 'your_account_sid', password: 'your_auth_token' }
    // });
    // Store OTP temporarily (e.g., in a table or Redis)

    await pool.query(
        `INSERT INTO otps (user_idc, otp, expires_at) 
        VALUES ($1, $2 , $3)`,
        [result.rows[0].id, otp, new Date(Date.now() + 10 * 60 *1000)] // OTP valid for 10 minutes

    );
    res.stastus(201).json({
        user:result.rows[0], message:'OTP sent to your phone number. Please verify to complete registration.'
    });
}
    catch (error){
        res.status(500).json({error: 'error.message'});
    }

});

//OTP table for temporary storage

const createOtpTable = async () => {

    await pool.query(
        `CREATE TABLE IF NOT EXISTS otps (
            id SERIAL PRIMARY KEY,
            user_id INT REFERENCES users(id),
            otp VARCHAR(6) NOT NULL,
            expires_at TIMESTAMP NOT NULL
        )`
    );

};

createOtpTable();
app.listen(3000, () => {
    console.log('Server running on port 3000');
});

