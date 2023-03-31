import argparse
import yaml

def keyEligibleForConversion(key):
    eligible = True
    if '_pc' in key or key.startswith('year') or 'proportion' in key:
        eligible = False
    return eligible

def valueEligibleForConversion(value):
    eligible = False
    if value is not None and len(str(value)) > 3:
        eligible = True
    return eligible

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("inputfile", type=str)
    parser.add_argument("outputfile", type=str)
    args = parser.parse_args()

    with open(args.inputfile, 'r') as f_in:
        myyaml = yaml.load(f_in, Loader=yaml.SafeLoader)
        myyaml = convertDict(myyaml)
    with open(args.outputfile, 'w') as f_out: 
        yaml.dump(myyaml, f_out)    

def convertDict(mydict):
    for key,value in mydict.items():
        if type(value) is dict:
            mydict[key] = convertDict(value)
        elif keyEligibleForConversion(key) and valueEligibleForConversion(value):
            mydict[key] = '{:,}'.format(value)
    return mydict

if __name__ == '__main__':
    main()

    
