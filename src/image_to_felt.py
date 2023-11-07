import binascii
from starknet_py.cairo.felt import decode_shortstring, encode_shortstring

class Felt:
    def __init__(self, content):
        hex_content = binascii.hexlify(content).decode('utf-8')
        self.content = hex_content
    
    def __str__(self):
        return self.content
    



# Open the image file in binary mode
with open('NFT-onchain/assets/image.jpg', 'rb') as image_file:
    image_data = image_file.read()

# Initialize a list to store the "felt" structs
hexas = []

# Iterate through the image data in 31-byte chunks
for i in range(0, len(image_data), 15):
    chunk = image_data[i:i+15]  # Extract a 31-byte chunk
    if len(chunk) < 15:
        chunk += b'\x00' * (15 - len(chunk))  # Pad with null bytes if necessary
    felt = Felt(chunk)
    hexas.append(felt)


felts = []
for h in hexas:
    #print(h)
    felts.append(encode_shortstring(h.content))

#print(felts[-1])

# let felt_array: Array<felt252> = array![
# ]

with open('output.cairo', 'w') as file:
    file.write("let felt_array: Array<felt252> = array![\n")
    for idx, f in enumerate(felts):
        file.write("\t" + str(f))
        if idx < len(felts) - 1:
            file.write(",")
        file.write("\n")
    file.write("]\n")


