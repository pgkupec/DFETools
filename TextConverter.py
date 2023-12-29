import os
from itertools import product, permutations

os.system('cls' if os.name == 'nt' else 'clear')

print('Password Case Converter Script')
print('Written by: Peter Kupec')
print('WCSO Criminal Enforcement Team\n')

print('This script will take a given password string and convert it to all possible combinations of that string using lowercase and uppercase letters. For example, abc will be saved as: abc Abc aBc abC ABc AbC aBC ABC\n')
print('You will first be asked for a filename. This created text file will be saved in the same directory as the script. If the file already exists, it will open that file and append entered information to the end of the file.\n')
print('Please only enter password text in lowercase. The script will take care of all the capitalization!\n')

fname = input('Enter a filename to save the results to: ')
filename = fname + '.txt'

if os.path.exists(filename):
    write_mode = 'a' # append if already exists
    print('Existing file found. New information will be added to the end of the file.\n')
else:
    write_mode = 'w' # make a new file if not
    print('File has ben created.\n')
    
f= open("%s.txt" % fname, write_mode)

words = [input('Enter a password to permutate (type x to exit): ')]

while words[0] != 'x':
    cases = []
    for word in words:
        pr = product(*zip(word, word.upper()))
        cases += [set(map(''.join, pr))]

    for perm in permutations(cases):
        for prod in product(*perm):
            f.write(''.join(prod) + '\n')
    
    if not words[0]:
        print('Nothing entered. Please try again!\n')
        words = [input('Enter a password to permutate (type x to exit): ')]
    else:
        print('All possible combinations have been added to the list.\n')
    words = [input('Enter a password to permutate (type x to exit): ')]
else:
    print('\nCase converted password list has been saved to: ' + filename)