<?php
# *****************************************************************************
# Lab 15: Consume data from the Plumber API Output (using PHP) ----
#


// Function to make the API request and process the response
function makeApiRequest($params) {
    // Set the API endpoint URL
    $apiUrl = 'http://127.0.0.1:5022/diabetes';

    // Initiate a new cURL session/resource
    $curl = curl_init();

    // Set the cURL options
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($curl, CURLOPT_URL, $apiUrl . '?' . http_build_query($params));

    // Make a GET request
    $response = curl_exec($curl);

    // Check for cURL errors
    if (curl_errno($curl)) {
        $error = curl_error($curl);
        // Handle the error appropriately
        die("cURL Error: $error");
    }

    // Close cURL session/resource
    curl_close($curl);

    // Decode the JSON into normal text
    $data = json_decode($response, true);

    // Check if the response was successful
    if (isset($data['0'])) {
        // API request was successful
        // Access the data returned by the API
        echo "The predicted diabetes status is:<br>";

        // Process the data
        foreach ($data as $repository) {
            echo $repository['0'], $repository['1'], $repository['2'], "<br>";
        }
    } elseif (isset($data['message'])) {
        // API request returned an error with a message
        echo "API Error: " . $data['message'];
    } else {
        // API request failed without a specific message
        echo "API Error: Unknown error";
    }
}

// Initialize variables
$output = '';

// Check if the form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get the form values
    $arg_pregnant = $_POST['arg_pregnant'];
    $arg_glucose = $_POST['arg_glucose'];
    $arg_pressure = $_POST['arg_pressure'];
    $arg_triceps = $_POST['arg_triceps'];
    $arg_insulin = $_POST['arg_insulin'];
    $arg_mass = $_POST['arg_mass'];
    $arg_pedigree = $_POST['arg_pedigree'];
    $arg_age = $_POST['arg_age'];

    // Set the parameters for the API request
    $params = array(
        'arg_pregnant' => $arg_pregnant,
        'arg_glucose' => $arg_glucose,
        'arg_pressure' => $arg_pressure,
        'arg_triceps' => $arg_triceps,
        'arg_insulin' => $arg_insulin,
        'arg_mass' => $arg_mass,
        'arg_pedigree' => $arg_pedigree,
        'arg_age' => $arg_age
    );

    // Make the API request and store the output
    ob_start(); // Start output buffering
    makeApiRequest($params);
    $output = ob_get_clean(); // Get the buffered output and clear the buffer
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lab 15 Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        form {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            text-align: left;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
        }

        input {
            width: 100%;
            padding: 8px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        input[type="submit"] {
            background-color: #4caf50;
            color: #fff;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #45a049;
        }

        .output {
            margin-top: 20px;
            padding: 10px;
            background-color: #dff0d8;
            border: 1px solid #3c763d;
            border-radius: 4px;
            color: #3c763d;
        }
    </style>
</head>
<body>

    <h2 style="color: #333;">Lab 15 Form</h2>

    <form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
        
        <label for="arg_pregnant">Pregnant:</label>
        <input type="text" name="arg_pregnant" value="1"><br>

        <label for="arg_glucose">Glucose:</label>
        <input type="text" name="arg_glucose" value="85"><br>

        <label for="arg_pressure">Blood Pressure:</label>
        <input type="text" name="arg_pressure" value="66"><br>

        <label for="arg_triceps">Triceps:</label>
        <input type="text" name="arg_triceps" value="29"><br>

        <label for="arg_insulin">Insulin:</label>
        <input type="text" name="arg_insulin" value="0"><br>

        <label for="arg_mass">BMI:</label>
        <input type="text" name="arg_mass" value="26.6"><br>

        <label for="arg_pedigree">Pedigree:</label>
        <input type="text" name="arg_pedigree" value="0.351"><br>

        <label for="arg_age">Age:</label>
        <input type="text" name="arg_age" value="31"><br>

        <input type="submit" value="Submit">
    </form>

    <?php
    // Display the output only if the form is submitted
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        echo '<div class="output">';
        echo $output;
        echo '</div>';
    }
    ?>

</body>
</html>
