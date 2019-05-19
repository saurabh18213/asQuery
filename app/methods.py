
def convert_to_four_column_bootstrap_renderable_list(items):
    list_size = len(items)
    x = int(list_size / 4)

    if list_size % 4:
        x = x + 1

    k = -1
    final_list = []

    for i in range(0, x):
        clist = []
        
        for j in range(0, 4):
            k = k + 1
            
            if (k < list_size) :
                clist.append(items[k])
        

        final_list.append(clist)

    return final_list    