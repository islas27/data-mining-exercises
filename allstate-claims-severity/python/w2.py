import csv
import pandas as pd
import numpy as np

from sklearn.tree import DecisionTreeRegressor
from sklearn.neural_network import MLPRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import BaggingRegressor
from sklearn.ensemble import AdaBoostRegressor
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
    data = data.astype(float)
    if type == 1:
        #standarization
        data = (data - data.mean(axis = 0)) / data.std(axis = 0)
    if type == 2:
        #normalization (max & min)
        data = (data - np.min(data)) / (np.max(data) - np.min(data))
    data[:, -1] = loss
    return data

def errorCalculation(real, predicted):
    return mean_absolute_error(real, predicted)

# hold out method
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

def sampling(data, fraction, replaceStyle, seed):
    df = pd.DataFrame(data)
    sample = df.sample(fraction = fraction, replace = replaceStyle, random_state = seed)
    return sample.values

def dataMining(data, models, finalTest):
    allErrors = []
    for model in models:
        modelName = str(type(model)).split(".")[-1][:-2][:-len("Classifier")]
        print '----------------------------' + modelName + '----------------------------'
        modelError = []
        for z in range(1):
            data = dataScramble(data, 1809)
            data = normalization(data, 2, data[:, -1])
            train, test = dataSplit(data, 0.7)
            traint = train[:,-1].astype(float)
            testt = test[:,-1].astype(float)
            m = model.fit(np.delete(train, -1, 1), traint)
            error = errorCalculation(testt, m.predict(np.delete(test, -1,1)))
            print error
            lossOutput(m.predict(finalTest), finalTest[:,0], modelName, z)
            modelError.append(error)
        allErrors.append(np.array(modelError).mean(axis = 0))

train = readFile('datasets/train.csv')
finalTest = readFile('datasets/test.csv')

train, finalTest = numericTransform(train, finalTest)

models = [DecisionTreeRegressor(),
RandomForestRegressor(),
AdaBoostRegressor(),
BaggingRegressor(),
MLPRegressor()
]

dataMining(train, models, finalTest)
