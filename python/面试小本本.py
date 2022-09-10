#输入
n=int(input())
n,m=map(int,input().strip().split())
p=list(map(int,input().strip().split()))
#且
res = dict(dict1.items() & dict2.items() & dict3.items())
#循环与if
for i in range(1, n+1):
    for j in range(1,n+1):
        if abs(i-x1)+(j-y1)==dist1:
            dict1[(i,j)]=1
        if abs(i-x2)+(j-y2)==dist2:
            dict2[(i,j)]=1
        if abs(i-x3)+(j-y3)==dist3:
            dict3[(i,j)]=1
#append（n*2）list
for i in range(0,n):
    e.append(a[i]*p[i])
#(n*m)list
dp = [[float('inf')for _ in range(m+1)]for _ in range(n+1)]
#小数点
print('%.2f' % sum)
print(round(sum,2))
#排序
e.sort(key=lambda x : x[0],reverse=True)

