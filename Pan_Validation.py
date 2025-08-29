import pandas as pd
import re

df = pd.read_excel('PAN Number Validation Dataset.xlsx')
"""print(df.head(10))
print('Total Records =',len(df))"""
total_records = len(df)

#Data Cleaning 
#Converting into string upper case
df['Pan_Numbers'] = df['Pan_Numbers'].astype('string').str.strip().str.upper()
print(df.head(10))

#Identifying Blank Values
print('\n')
print(df[df['Pan_Numbers']==''])
print(df[df['Pan_Numbers'].isna()])

#coverting blank values to NA
df = df.replace({'Pan_Numbers':''}, pd.NA)
print(df[df['Pan_Numbers']==''])
print(df[df['Pan_Numbers'].isna()])

#removing na values
df = df.replace({'Pan_Numbers':''}, pd.NA).dropna(subset='Pan_Numbers')
print('Total Records =',len(df))

#Identifying Total Unique and Duplicate values
print('Unique Values =',df['Pan_Numbers'].nunique())

#Removing Duplicate Values
df = df.drop_duplicates(subset='Pan_Numbers', keep='first')
print('Total Records =',len(df))

#Validation
#Identifying Adjacent characters (like AABCD is invalid; AXBCD is valid)
#All five characters cannot form a sequence 
#(like: ABCDE, BCDEF is invalid; ABCDX is valid)
#Adjacent characters(digits) cannot be the same 
# (like 1123 is invalid; 1923 is valid)
#All four characters cannot form a sequence (like: 1234, 2345)
#The last character should be alphabetic (uppercase letter).

"""def has_adjacent_repitation(pan):
    for i in range(len(pan)-1):
        if pan[i] == pan[i+1]:
            return True
        return False"""

#OR
def has_adjacent_repitation(pan):
    return any(pan[i] == pan[i+1] for i in range(len(pan)-1))

#example to check the function
"""print(has_adjacent_repitation('AABCD'))
print(has_adjacent_repitation('FGHHH'))
print(has_adjacent_repitation('ABCDX'))
print(has_adjacent_repitation('MNJPQ'))"""

#Checking for the sequence

"""def is_sequential(pan): #ABCDE
    for i in range(len(pan)-1):
        if ord(pan[i+1]) - ord(pan[i]) != 1:
            return False
    return True"""
#OR
def is_sequential(pan):
    return all(ord(pan[i+1]) - ord(pan[i]) == 1 for i in range(len(pan)-1))

"""print(is_sequential('ABCDE'))
print(is_sequential('MNOPQ'))
print(is_sequential('ABCXY'))
print(is_sequential('XYZAB'))"""

def is_valid_pan(pan):
    if len(pan) != 10:
        return False
    
    if not re.match(r'^[A-Z]{5}[0-9]{4}[A-Z]$',pan):
        return False
    
    if has_adjacent_repitation(pan):
        return False
    
    if is_sequential(pan):
        return False
    
    return True

df['Status'] = df['Pan_Numbers'].apply(lambda x: 'Valid' if is_valid_pan(x) else 'Invalid')
print(df.head(10))

valid_count = (df['Status']=='Valid').sum()    
invalid_count = (df['Status']=='Invalid').sum()
missing_count = total_records - (valid_count+invalid_count)

print('Total Records =', total_records)
print('Valid =', valid_count)
print('Invalid =', invalid_count)
print('Missing =',missing_count)

df_summary = pd.DataFrame({'TOTAL PROCESSED RECORDS': [total_records],
                            'TOTAL VALID COUNT': [valid_count],
                            'TOTAL INVALID COUNT': [invalid_count],
                            'TOTAL MISSING PANS': [missing_count]})

print(df_summary.head())

with pd.ExcelWriter("PAN VALIDATION RESULT.xlsx") as writer:
    df.to_excel(writer, sheet_name='PAN Validation', index=False)
    df_summary.to_excel(writer, sheet_name='SUMMARY',index=False)




