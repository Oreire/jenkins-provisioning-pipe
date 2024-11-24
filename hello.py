import socket
import threading

# Define host and port
HOST = '0.0.0.0'  # Localhost
PORT = 65432        # Port to listen on (use any free port number)

def handle_client(conn, addr):
    """Handle communication with a connected client."""
    print(f"Connected by {addr}")
    with conn:
      try:
        # Continuously listen for messages from this client
        while True:
         

            data = conn.recv(1024)  # 1024 bytes buffer size
            if not data:
                print(f"Connection closed by {addr}")
                break  # Exit loop if no data is received
            message = data.decode()
            print(f"Received message from {addr}: {message}")
            
            # Format the response as HTML
            html_response = f"""\
HTTP/1.1 200 OK
Content-Type: text/html

<html>
    <body>
        <h1>Your Message:</h1>
        <p>{message}</p>
    </body>
</html>
"""
            # Echo the HTML response back to the client
            conn.sendall(html_response.encode())
            print(f"Echoed back in HTML format to {addr}")
            conn.close()
      except:
       pass

# Create a socket object
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server_socket:
    # Bind the socket to the address and port
    server_socket.bind((HOST, PORT))
    # Enable the server to accept connections
    server_socket.listen()
    print(f"Server listening on {HOST}:{PORT}...")

    # Continuously accept and handle new connections
    while True:
        conn, addr = server_socket.accept()
        # Create a new thread to handle each client connection
        client_thread = threading.Thread(target=handle_client, args=(conn, addr))
        client_thread.start()
        print(f"Started thread for {addr}")

