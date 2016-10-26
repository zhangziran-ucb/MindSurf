# -*- coding: utf-8 -*-
"""
Created on Sun Sep 18 06:41:29 2016

@author: Robin
"""

import binascii
import matplotlib.pyplot as plt
import pandas as pd
from scipy import signal
import csv
import numpy as np
from scipy.cluster.vq import kmeans2,whiten

def somme (a, i1, i2):
    s=0.0
    for i in range(i2+1-i1):
        s=s+a[i1+i]
    return s

def ploter(a):
    plt.plot(a)
    plt.ylabel('some numbers')
    plt.show()

g= open('Robin-2.csv','rb')
gcsv = csv.reader(g, delimiter=',')
l = []
compt = 0
for row in gcsv:
    if (compt!=0):
        l.append(float(row[2])+float(row[3])+float(row[11]))
    compt = compt + 1

def traiter(l,l_chunk,nb_clusters):
    ta = (len(l)/l_chunk)-1
    a = np.zeros((ta,l_chunk))
    st= np.zeros((ta,1))
    a2 = np.zeros((ta,l_chunk))
    st2=np.zeros((ta,1))
    #print a[0:4,0:200]
    for i in range(ta):
        for j in range(l_chunk):
            a[i,j]= l[i*l_chunk+j]
            a2[i,j]= l[i*l_chunk+j+(l_chunk/2)]
        st[i,0]=somme(a[i],0,l_chunk-1)
        st2[i,0]= somme(a2[i],0,l_chunk-1)
    
    #print st
    continuum = np.zeros((2*ta,1))
    c2=np.zeros((2*ta,l_chunk))
    for i in range(ta):
        continuum[2*i,0]=st[i,0]
        continuum[2*i+1,0]=st2[i,0]
        c2[2*i]=a[i]
        c2[2*i+1]=a2[i]
    
    
#    print type(a2[0])
#    plt.plot(continuum)
#    plt.ylabel('some numbers')
#    plt.show()
#    
    
   
    w = whiten(continuum)
#    plt.plot(w)
#    plt.ylabel('some numbers')
#    plt.show()
    
    
    k,c = kmeans2(w,nb_clusters,50, minit='points')
    print k
    print c
    plt.plot(c)
    plt.ylabel('some numbers')
    plt.show()
    
    ind_imp= 0
    ou1 = somme(c,0,len(c)-1)
    if (ou1<len(c)/2):
        ind_imp=1
    else:
        ou1=len(c)-ou1
    
    #print c
    
    inds = []
    for i in range(len(c)):
        if (c[i]==ind_imp):
            inds.append(i)
    
    print inds
    for i in inds:
        ploter(c2[i])
    return ou1   
    
def trouver_l_chunk(l_min,rang):    
    for j in range(5):
        li = []
        for i in range (rang):
            li.append(traiter(l,rang + l_min,2))
        ploter(li)
        return min(li),li.index(min(li))

#trouver_l_chunk(60,60)
traiter(l,95,2)
#f, Pxx_den = signal.welch(a[0:100,0], 128)
#plt.semilogy(f, Pxx_den)
#plt.xlabel('frequency [Hz]')
#plt.ylabel('PSD [V**2/Hz]')
#plt.show()
#sh = str(h)
##print sh
#val_list =sh.split("aaaa2002")
#
#val_list =sh.split("aaaa048002")
#
#val_list = val_list[1:len(val_list)-1]
#h_up=[]
#h_high=[]
#h_signed=[]
#compt = 0
#flag = []
#for h in val_list:
#    h_up.append(int(h,16))
#    if (int(h,16)<3000000):
#        
#        h_signed.append(int(h,16))
#    else:
#        h_up.append(h_up[len(h_up)-1])
#        
#        if (int(h,16)<170000000):
#            h_signed.append(0 -(16777216 - int(h,16)))
#            h_high.append(int(h,16))
#            flag.append(compt)
#        else:
#            h_signed.append(h_signed[len(h_signed)-1])
#    compt = compt + 1
#    
##○print h_list[1:len(val_list)]
#print flag
#print len(flag)
#print h_signed[1540:1550]
#plt.plot(h_signed)
#plt.ylabel('Amplitude')
#plt.xlabel('Time')
#plt.show()
#plt.plot(h_signed[1500:1704])
#plt.ylabel('some numbers')
#plt.show()
#
#data = {'signal':h_signed} 
#df = pd.DataFrame(data)
#h_mean= pd.rolling_mean(df,10)
#h_median=pd.rolling_median(df,10)
#h_ewna=pd.ewma(df,alpha=0.1)
#plt.plot(h_mean)
#plt.ylabel('Amplitude')
#plt.xlabel('Time')
#plt.show()
#plt.plot(h_median)
#plt.ylabel('Amplitude')
#plt.xlabel('Time')
#plt.show()
#plt.plot(h_ewna)
#plt.ylabel('Amplitude')
#plt.xlabel('Time')
#plt.show()
##plot(h_list[1:len(val_list)-1])
##plot.show()
#
#
#f, Pxx_den = signal.welch(h_signed[1000:2000], 512)
#plt.semilogy(f, Pxx_den)
#plt.xlabel('frequency [Hz]')
#plt.ylabel('PSD [V**2/Hz]')
#plt.show()
#f, Pxx_den = signal.welch(h_signed[2000:3000], 512)
#plt.semilogy(f, Pxx_den)
#plt.xlabel('frequency [Hz]')
#plt.ylabel('PSD [V**2/Hz]')
#plt.show()
#f, Pxx_den = signal.welch(h_signed[3000:4000], 512)
#plt.semilogy(f, Pxx_den)
#plt.xlabel('frequency [Hz]')
#plt.ylabel('PSD [V**2/Hz]')
#plt.show()
