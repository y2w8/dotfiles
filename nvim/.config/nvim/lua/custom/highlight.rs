// This is a single-line comment (Should be Italic and Cursive)
/* This is a multi-line comment.
   Check if the italics look elegant here.
*/

use std::collections::HashMap; // 'use' should be italic

#[derive(Debug)] // Attributes often look good in italic
pub struct User {
    pub id: u64,           // 'u64' (Type) should be Bold
    pub username: String,  // 'String' (Type) should be Bold
}

fn main() {
    // 'let', 'mut', 'if' should be Italic
    let mut scores = HashMap::new(); 

    scores.insert(String::from("Blue"), 10);

    let user_name = "Gemini"; // String should be normal/regular

    // Conditionals: 'if' and 'else' should be Italic
    if user_name == "Gemini" {
        println!("Welcome to the system!"); // Macro!
    } else {
        println!("Access Denied");
    }
}
