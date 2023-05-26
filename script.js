const contractAddress = "0xcc2bDFAA45FD5fe6021117F198491134C3F75aE9"; // Replace with the deployed contract address
const contractABI = [
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "stringMathExpression",
				"type": "string"
			}
		],
		"name": "computeStringExpression",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "computedValue",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];
    

let connectedAddress = null;
let walletConnected = false;
let computedValue = null;
let web3 = null;
let contractInstance = null;
let requiredNetworkId = "8082";

// Function to initialize Web3 and the contract instance
async function initialize() {
  // Check if Web3 is already injected by the browser (e.g., MetaMask)
  if (typeof window.ethereum !== "undefined") {
    web3 = new Web3(window.ethereum);
    await window.ethereum.enable(); // Request user's permission to connect to the wallet
  } else {
    console.log("No Ethereum wallet found. Please install MetaMask.");
  }

  // Check if the web3 object has been initialized
  if (web3 !== null) {
    contractInstance = new web3.eth.Contract(contractABI, contractAddress);
  }
}

// Function to compute the string expression using the smart contract
async function computeStringExpression(expression) {
  try {
    await contractInstance.methods.computeStringExpression(expression).send({ from: web3.eth.defaultAccount });
    computedValue = await contractInstance.methods.computedValue().call();
    console.log("Computed Value:", computedValue);
  } catch (error) {
    console.log("Transaction error:", error.message);
  }
}

// Function to handle the form submission
async function showresult(event) {
  event.preventDefault();

  const expressionInput = document.getElementById("expression");
  const expression = expressionInput.value.trim();

  if (expression !== "") {
    await computeStringExpression(expression);
    expressionInput.value = ""; // Clear the input field
  } else {
    console.log("Expression can't be computed.");
  }
}

// Function to connect the wallet
async function connectWallet() {
  if (typeof window.ethereum !== "undefined") {
    try {
      await window.ethereum.request({ method: "eth_requestAccounts" });
      web3.eth.defaultAccount = window.ethereum.selectedAddress;
      console.log("Wallet connected:", web3.eth.defaultAccount);
    } catch (error) {
      console.log("No accounts found in your wallet.");
    }
  } else {
    console.log("No Ethereum wallet found. Please install MetaMask.");
  }
}

// Event listener for form submission
const form = document.getElementById("calculator-form");
form.addEventListener("submit", handleSubmit);

// Event listener for wallet connection button
const connectWalletButton = document.getElementById("connectWalletButton");
connectWalletButton.addEventListener("click", connectWallet);

// Initialize Web3 and contract instance
initialize();
// Event listener for input value changes
    expressionInput.addEventListener('input', function() {
      enableComputeAndResultButtons();
    });

  </script>
