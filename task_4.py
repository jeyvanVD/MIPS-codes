"""
This code is made by Jeyvan Viriya (29802245) for task_4 FIT 1008
"""
def bubble_sort(the_list):
    """
    this function refers to the bubble sort process which iterates on  a  list, checking if the previous value is bigger
    or smaller than the next number. If it is bigger, then switch the two values.
    :param the_list: the list which needs to be sorted
    :return: the sorted list
    :pre-condition: The list must be a valid list which is not empty
    :post-condition:   The list will have been sorted
    :worst-case time complexity: O(n^2) as there are two corresponding loops
    :best-case time complexity" O(n^2) as there are no way to stop the loop earlier
    """
    listLength = len(the_list)
    i = 0
    x = -1
    while i<listLength:
        while x < i:
            if the_list[x] > the_list[x+1]:
                temp = the_list[x]
                the_list[x]=the_list[x+1]
                the_list[x+1] = temp
                x = -1
            x+=1
        i+=1
        
    i=0
    while i<listLength:
        print(the_list[i])
        i+=1
# listA = [75,20,60,41,7]
listA = [54, 26, 93, 17, 77, 31, 44, 55, 20, -99, 0]
bubble_sort(listA)





