n=int(input())
a1=list(map(int, input().split()))
a2=list(map(int, input().split()))
a3=list(map(int, input().split()))
c=list(map(int, input().split()))
b=list()
for i in range(0,n,1) :
    for j in range(0,n,1) :
        b1=abs(i-a1[0])+abs(j-a1[1])
        b2=abs(i-a2[0])+abs(j-a2[1])
        b3=abs(i-a3[0])+abs(j-a3[1])
        if c[0]==b1 | c[1]==b2 | c[2]==b3 : print(i+' '+j)
        else : print('no')




for i in range(0,m-1,1) :
    
