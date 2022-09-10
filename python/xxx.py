'''
本人专业为统计学，研究方向为数理统计，主要研究对象为由信息技术快速发展而出现的高维大数据模型，结合半参数模型对研究对象进行建模分析等相关数据分析；
在校期间，任职数统学院学生会副主席，期间曾组织数统学院数海论坛统计年会、重庆工商大学研究生运动会等多项活动；
在亚信科技的实习期间，通过结合自身的统计学相关知识基础，完成了项目组负责的各项数据分析提取任务，期间主要使用sql开发语言，能够熟练的使用gbase和hive等关系型数据库。
'''

'''
小团在地图上放了三个定位装置,想依赖他们来进行定位:(题2)
小团的地图是一个n×n的一个棋盘,他在(x1,y1),(x2,y2),(x3,y3) xi,yi ∈ Z ∩ [1,n] 这三个位置分别放置了一个定位装置（两两不重叠）。
然后小团在一个特定的位置(a,b)a,b ∈ Z ∩ [1,n]放置了一个信标。每个信标会告诉小团它自身到那个信标的曼哈顿距离,即对i=1,2,3 
小团知道(|xi-a|+|yi-b|),现在小团想让你帮他找出信标的位置！注意,题目保证最少有一个正确的信标位置。
因为小团不能定位装置确定出来的信标位置是否唯一,如果有多个,输出字典序最小的那个。(a,b)的字典序比(c,d)小,当且仅当 a<c或者a==c∧b<d


第一行一个正整数n,表示棋盘大小。
第二行两个整数,分别表示x1与y1,即第一个定位器的位置。
第三行两个整数,分别表示x2与y2,即第二个定位器的位置。
第四行两个整数,分别表示x3与y3,即第三个定位器的位置。
第五行三个整数,分别表示第一、二、三个定位器到信标的曼哈顿距离。第i个定位器到信标的曼哈顿距离即(|xi-a|+|yi-b|)
数字间两两有空格隔开,对于所有数据, n≤50000, 1≤xi,yi≤n

思路:
直接暴力,遍历所有满足要求的点,然后求交集。

n = int(input())
x1, y1 = map(int, input().strip().split())
x2, y2 = map(int, input().strip().split())
x3, y3 = map(int, input().strip().split())
dis1, dis2, dis3 = map(int, input().strip().split())
hash1, hash2, hash3 = dict(), dict(), dict()
for i in range(1, n+1):
    for j in range(1, n+1):
        if abs(i-x1)+abs(j-y1) == dis1:
            hash1[(i,j)] = 1
        if abs(i-x2)+abs(j-y2) == dis2:
            hash2[(i,j)] = 1
        if abs(i-x3)+abs(j-y3) == dis3:
            hash3[(i,j)] = 1
# res = dict()
resdict = dict(hash1.items() & hash2.items() & hash3.items())
common = []
for key, val in resdict.items():
    # for i in range(0, val):
    common.append(key)
x, y = common[0]
print(x,y)
// vx公众号关注TechGuide 实时题库 闪电速递
'''

n=int(input())
x1,y1=map(int,input().strip().split())
x2,y2=map(int,input().strip().split())
x3,y3=map(int,input().strip().split())
dist1,dist2,dist3 = map(int,input().strip().split())
dict1,dict2,dict3 =dict(),dict(),dict()
for i in range(1, n+1):
    for j in range(1,n+1):
        if abs(i-x1)+(j-y1)==dist1:
            dict1[(i,j)]=1
        if abs(i-x2)+(j-y2)==dist2:
            dict2[(i,j)]=1
        if abs(i-x3)+(j-y3)==dist3:
            dict3[(i,j)]=1
res = dict(dict1.items() & dict2.items() & dict3.items())
common=[]
for key,val in res:
    common.append(key)
try:
    x, y = common[0]
    print(x,y)
except:
    print('no')

'''
小美将要期中考试,有n道题,对于第i道题,小美有pi的几率做对,获得ai的分值,还有(1-pi)的概率做错,得0分。
小美总分是每道题获得的分数。
小美不甘于此,决定突击复习,因为时间有限,她最多复习m道题,复习后的试题正确率为100%。
如果以最佳方式复习,能获得期望最大总分是多少？

输入n、m
接下来输入n个整数,代表pi%,为了简单期间,将概率扩大了100倍。
接下来输入n个整数,代表ai,某道题的分值
输出最大期望分值,精确到小数点后2位

输入描述
2 1
89 38
445 754


输出描述
1150.05
'''
n,m=map(int,input().strip().split())
p=list(map(int,input().strip().split()))
a=list(map(int,input().strip().split()))
e=[]
sum=0
for i in range(0,n):
    e.append([(100-p[i])/100*a[i],a[i]])

e.sort(key=lambda x : x[0],reverse=True)

for j in range(len(p)):
    if j<m:
        sum += e[j][1]
    else : sum += e[j][1] - e[j][0]
print(sum)

'''
题目描述
小团生日收到妈妈送的两个一模一样的数列作为礼物！他很开心的把玩,不过不小心没拿稳将数列摔坏了！
现在他手上的两个数列分别为A和B, 长度分别为n和m。小团很想再次让这两个数列变得一样。他现在能做两种操作,
操作一是将一个选定数列中的某一个数a改成数b, 这会花费|b-a|的时间,操作二是选择一个数列中某个数a,
将它从数列中丢掉,花费|a|的时间。小团想知道,他最少能以多少时间将这两个数列变得再次相同！

输入描述
第一行两个空格隔开的正整数n和m,分别表示数列A和B的长度。
接下来一行n个整数,分别为A1 A2...An
接下来一行m个整数,分别为B1 B2...Bm
对于所有数据,1≤n,m≤2000, |Ai|,|Bi|≤10000

输出描述
输出一行一个整数,表示最少花费时间,来使得两个数列相同。

思路
让两个数列变得一样。可以消去一个数a,代价是abs(a),或者这个数a改成b,代价是abs(a-b)。最小的代价是多少（类似编辑距离）
'''

4 4
1 2 3 3
1 2 3 4


n, m = map(int, input().split())
A = list(map(int, input().split()))  # n
B = list(map(int, input().split()))  # m
dp = [[float('inf')for _ in range(m+1)]for _ in range(n+1)]
dp[0][0] = 0
for i in range(1, n + 1):
    dp[i][0] = abs(A[i-1]) + dp[i-1][0]
for j in range(1, m+1):
    dp[0][j] = abs(B[j-1]) + dp[0][j-1]
for i in range(1, n+1):
    for j in range(1, m+1):
        if A[i-1] != B[j-1]:
            v1 = dp[i-1][j] + abs(A[i-1])  # 删除A[i-1]
            v2 = dp[i][j-1] + abs(B[j-1])  # 删除B[j-1]
            v3 = dp[i-1][j-1] + abs(A[i-1]- B[j-1])  # 把A[i-1]变成B[j-1]
            dp[i][j] = min(v1, v2, v3)
        else:
            dp[i][j] = dp[i-1][j-1]
print(dp[-1][-1])



'''
小美的火箭有一些地方坏了，为了修补一个地方，需要使用材料压着，幸好她有很多种这样的材料。火箭上有n个地方坏了，
每个地方至少需要bi单位重量的材料压住 小妹有m种材料，每种材料重量为aij 同时要求：一个地方只能使用一个材料，材料需要尽量小。

输入：n、m 输入n个数代表b序列 输入m个数代表a序列

输出最小总重量，如果没法满足，输出-1。
'''

n, m = map(int, input().split())
a = list(map(int, input().split())) 
b = list(map(int, input().split()))  
sum=0
b.sort()
if max(a) <= b[-1]:
    for i in a :
        for j in b :
            if i <= j :
                sum += j
                break
else : sum=-1
print(sum)


https://blog.csdn.net/qq_38253797/article/details/126466289


for i in range(6):
        for j in range(6):
            if i < 0 or j < 0:
                print(i,j,1)
            elif 1:
                print(i,j,2)
            else:
                print(i,j,3)
