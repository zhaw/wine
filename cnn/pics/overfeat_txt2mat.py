import os

task_folder = ['train_overfeat/', 'test2_cutted_overfeat/']

for folder in task_folder:
    files = os.listdir(folder);
    for file_name in files:
        if file_name.endswith('txt'):
            with open(folder+file_name) as f:
                text = f.read()
            lines = text.split('\n')
            for line in lines:
                if len(line) > 100:
                    text = line.replace(' ',',')
            with open(folder+file_name.split('.')[0]+'.csv','w') as f:
                f.write(text.strip(','))
