import binascii
from starknet_py.cairo.felt import decode_shortstring, encode_shortstring

class Felt:
    def __init__(self, content):
        hex_content = binascii.hexlify(content).decode('utf-8')
        self.content = hex_content
    
    def __str__(self):
        return self.content
    

bytes = []
felts = []

# Open the image file in binary mode
with open('/home/uri/nft-onchain/output.cairo', 'r') as cairo_file:
    cairo_data = cairo_file.read()


skip = "\t\n,[]"
felt = ""

for i in range(0, len(cairo_data)):
    if i < 41 or cairo_data[i] in skip:
        continue
    if len(felt) == 72: #size of a felt
        felts.append(int(felt))
        bytes.append(decode_shortstring(felts[-1]))
        felt = ""
        felt += cairo_data[i]
        print(felts[-1])
    else:
        felt += cairo_data[i]

felts.append(int(felt))
felt = ""

with open('output.jpg', 'w') as file:
    for b in bytes:
        file.write(b)


