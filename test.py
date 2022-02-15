import unittest
import hashlib
import sys

def md5(file):
    md5 = hashlib.md5()
    with open(file, 'rb') as handle:
        data=handle.read()
    md5.update(data)
    return md5.hexdigest()

def compareline(file1, file2):
    f1 = open(file1)  
    f2 = open(file2)
    line = 0
    for line1 in f1:
        line += 1
        for line2 in f2:
            if line1 == line2:
                pass
            else:
                return False
            break
    return True

class Test(unittest.TestCase):
    input = 'test1.log'
    output = 'test2.log'

    def test_fileHashMatch(self):
        self.assertEqual(md5(self.input), md5(self.output), 'input/output DO NOT Match')
    
    def test_fileCompareLine(self):
        self.assertTrue(compareline(self.input, self.output))

if __name__ == '__main__':
    if len(sys.argv) > 1:
        Test.input = sys.argv.pop()
        Test.output = sys.argv.pop()
    unittest.main()