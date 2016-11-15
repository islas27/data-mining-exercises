import csv
import pandas as pd
import numpy as np

from sklearn.tree import DecisionTreeRegressor
from sklearn.svm import SVR
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import ExtraTreesRegressor
from sklearn.ensemble import BaggingRegressor
from sklearn.ensemble import AdaBoostRegressor
from sklearn.neighbors import KNeighborsRegressor
from sklearn.metrics import mean_absolute_error

def readFile(fileName):
    dt = pd.read_csv(fileName)
    return dt.values

def numericTransform(train, test):
    data = np.concatenate((np.delete(train, -1, 1), test),axis = 0)
    dictionary = []
    indexes = []

    for column in range(len(data[0])):
        if type(data[0][column]) == str:
            dictionary.append(np.unique(data[:,column]))
            indexes.append(column)

    for i in range(len(dictionary)):
        for j in range(len(dictionary[i])):
            train[np.where(train[:,indexes[i]] == dictionary[i][j]), indexes[i]] = j
            test[np.where(test[:,indexes[i]] == dictionary[i][j]), indexes[i]] = j

    return train, test

def dataScramble(data, seed):
    indexes = np.arange(data.shape[0])
    np.random.seed(seed)
    np.random.shuffle(indexes)
    data = data[indexes]

    return data

def normalization(data, type, loss):
    if type == 1:
        #standarization
        data = data.astype(float)
        mean = data.mean(axis = 0)
        std = data.std(axis = 0)
        data = (data - mean)/std
        data[:, -1] = loss


    return data

def errorCalculation(real, predicted):
    return mean_absolute_error(real, predicted)

def dataSplit(data, trainPercentage):
    if trainPercentage > 1:
        trainPercentage = .70

    trainSize = len(data) * trainPercentage

    train = data[0:trainSize]
    test = data[trainSize:len(data)-1]

    return train, test

def lossOutput (predicted, indexes, modelName, idM):
    fileName = 'submission_' + modelName + '_' + str(idM) + '.csv'
    f = open(fileName, "w")
    f.write("id,loss\n")
    for i in range(len(indexes)):
        f.write(str(indexes[i]) + "," + "{0:.2f}".format(predicted[i]) + "\n")
    f.close

def dataMining(data, model, finalTest):
    allErrors = []
    for model in models:
        modelName = str(type(model)).split(".")[-1][:-2][:-len("Classifier")]
        print '----------------------------' + modelName + '----------------------------'
        modelError = []
        for z in range(1):
            data = dataScramble(data, 1809)
            data = normalization(data, 1, data[:, -1])
            train, text = dataSplit(data, 0.7)
            traint = train[:,-1].astype(float)
            testt = text[:,-1].astype(float)

            m = model.fit(np.delete(train, -1, 1), traint)

            error = errorCalculation(testt, m.predict(np.delete(text, -1,1)))
            print error

            lossOutput(m.predict(finalTest), finalTest[:,0], modelName, z)

            modelError.append(error)

        allErrors.append(np.array(modelError).mean(axis = 0))

train = readFile('../train.csv')
finalTest = readFile('../test.csv')

train, finalTest = numericTransform(train, finalTest)

models = [DecisionTreeRegressor(),
RandomForestRegressor(),
AdaBoostRegressor(),
BaggingRegressor(),
ExtraTreesRegressor(),
KNeighborsRegressor(),
SVR()]

dataMining(train, models, finalTest)
