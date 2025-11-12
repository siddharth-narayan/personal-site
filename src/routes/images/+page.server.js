import fs from 'fs';
import path from 'path';

export async function load() {
  // Path to the static folder
  const staticFolder = path.resolve('static/images');
  
  // Read files from the static folder
  const files = fs.readdirSync(staticFolder);
  
  // Filter for image files only (e.g., .jpg, .png, .gif)
  const imageFiles = files.filter(file =>
    /\.(jpg|jpeg|png|gif|svg)$/i.test(file)
  );

  const imagePaths = imageFiles.map(file => `/images/${file}`);

  // Return the list of image paths
  return {
    images: imagePaths
  };
}