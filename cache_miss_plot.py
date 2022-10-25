import yaml
import csv
import matplotlib.pyplot as plt


def plot_bandwidth_profile():

    with open('cache_miss.yaml') as f:
        data = yaml.load(f, yaml.FullLoader)
        xlim = data['xlim']
        ylim = data['ylim']
        bw_profile_path = data['bw_profile_path_no']
        plot_path = data['plot_path']
        calibration = data['calibration_no']
        

    time_list = []
    fetch_list = []
    total_fetch = 0.0
    with open(bw_profile_path) as f:
        reader = csv.reader(f)
        
        for i, line in enumerate(reader):
        
            time = float(line[0].split()[2].split(':')[0]) - float(calibration)
            fetch_count = float(line[0].split()[3])

    #        time = float(line[0].split()[1].split(':')[0]) - float(calibration)
     #       fetch_count = float(line[0].split()[2])
            total_fetch += fetch_count
            time_list.append(time)
            fetch_list.append(fetch_count)

        #print(time_list)

    #print(calibration+time_list[len(time_list)-1])
    print(total_fetch *64 /(time_list[len(time_list)-1]-time_list[0])/ 1000000000.0)
    ax1 = plt.subplot()
    ax1.set_ylabel('LLC misses')
    ax1.set_xlabel('Time(s)')    
    lns1= ax1.plot(time_list, fetch_list, 'black', label='w/o memguard')


    with open('cache_miss.yaml') as f:
        data = yaml.load(f, yaml.FullLoader)
        bw_profile_path = data['bw_profile_path_yes_2000']
        plot_path = data['plot_path']
        calibration = data['calibration_yes_2000']
        

    time_list = []
    fetch_list = []
    total_fetch = 0.0
    with open(bw_profile_path) as f:
        reader = csv.reader(f)
        
        for i, line in enumerate(reader):
        
            time = float(line[0].split()[2].split(':')[0]) - float(calibration)
            fetch_count = float(line[0].split()[3])

    #        time = float(line[0].split()[1].split(':')[0]) - float(calibration)
     #       fetch_count = float(line[0].split()[2])
            total_fetch += fetch_count
            time_list.append(time)
            fetch_list.append(fetch_count)

        #print(time_list)

    #print(calibration+time_list[len(time_list)-1])
    print(total_fetch *64 /(time_list[len(time_list)-1]-time_list[0])/ 1000000000.0)
    ax1 = plt.subplot() 
    #lns2= ax1.plot(time_list, fetch_list, '-g', label='Memguard(2.0GB/s)')

    with open('cache_miss.yaml') as f:
        data = yaml.load(f, yaml.FullLoader)
        bw_profile_path = data['bw_profile_path_yes_1500']
        plot_path = data['plot_path']
        calibration = data['calibration_yes_1500']
        

    time_list = []
    fetch_list = []
    total_fetch = 0.0
    with open(bw_profile_path) as f:
        reader = csv.reader(f)
        
        for i, line in enumerate(reader):
        
            time = float(line[0].split()[2].split(':')[0]) - float(calibration)
            fetch_count = float(line[0].split()[3])

    #        time = float(line[0].split()[1].split(':')[0]) - float(calibration)
     #       fetch_count = float(line[0].split()[2])
            total_fetch += fetch_count
            time_list.append(time)
            fetch_list.append(fetch_count)

        #print(time_list)

    #print(calibration+time_list[len(time_list)-1])
    print(total_fetch *64 /(time_list[len(time_list)-1]-time_list[0])/ 1000000000.0)
    ax1 = plt.subplot()
    lns3= ax1.plot(time_list, fetch_list, '-r', label='Memguard(1.5GB/s)')

    with open('cache_miss.yaml') as f:
        data = yaml.load(f, yaml.FullLoader)
        bw_profile_path = data['bw_profile_path_yes_1000']
        calibration = data['calibration_yes_1000']
        

    time_list = []
    fetch_list = []
    total_fetch = 0.0
    with open(bw_profile_path) as f:
        reader = csv.reader(f)
        
        for i, line in enumerate(reader):
        
      #      time = float(line[0].split()[2].split(':')[0]) - float(calibration)
     #       fetch_count = float(line[0].split()[3])

            time = float(line[0].split()[1].split(':')[0]) - float(calibration)
            fetch_count = float(line[0].split()[2])
            total_fetch += fetch_count
            time_list.append(time)
            fetch_list.append(fetch_count)

        #print(time_list)

    #print(calibration+time_list[len(time_list)-1])
    print(total_fetch *64 /(time_list[len(time_list)-1]-time_list[0])/ 1000000000.0)
    ax1 = plt.subplot()
    #lns4= ax1.plot(time_list, fetch_list, '-b', label='Memguard(1.0GB/s)')
 
    plt.xticks(fontsize=10)
    plt.yticks(fontsize=8)
    ax1.set_xlim(xlim)
    ax1.set_ylim(ylim)
    
    #lns = lns1 + lns2 + lns3 + lns4
    lns = lns1 + lns3
    labs = [l.get_label() for l in lns]
    ax1.legend(lns, labs, loc='upper left')

    # plt.show()
    plt.savefig(plot_path)
    plt.close()


if __name__ == '__main__':
    plot_bandwidth_profile()