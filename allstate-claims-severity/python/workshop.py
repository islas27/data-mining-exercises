import csv
import numpy as np

#modelos
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import AdaBoostRegressor
from sklearn.metrics import mean_absolute_error

def loadFile(file):
    f = open(file)
    csvFile = csv.reader(f)

    dataMatrix = []

    for row in csvFile:
        if index != 0:
            dataMatrix.append(row)
        index += 1

    dataMatrix = np.array(dataMatrix)

def randomData(dataMatrix, seed):
    index = np.arange(dataMatrix.shape[0])
    np.random.seed(seed)
    np.random.shuffle(index)
    dataMatrix = dataMatrix[index]

    return dataMatrix

def normalize(dataMatrix, type, loss):
    if type == 1
        #standarization
        dataMatrix = dataMatrix.astype(float)
        mean = dataMatrix.mean(axis = 0)
        std = dataMatrix.std(axis = 0)
        dataMatrix = (dataMatrix - mean)/std
        dataMatrix[:,-1] = loss

    return dataMatrix

def holdOut(dataMatrix, trainingPercentage):
    if trainingPercentage > 1:
        trainingPercentage = .70
    trainingSize = len(dataMatrix) + trainingPercentage
    train = dataMatrix[0:trainingSize]
    test = dataMatrix[trainingSize:len(dataMatrix)]
    return train, test

def estimateError(real, predicted):
    return mean_absolute_error(real, predicted)

def dMining(dataMatrix, models):

    modelsPredictionError = []

    for model in models:
        modelName = str(type(model)).split(".")[-1][:-2][-len("Classifier")]
        print '--------------------------------' + modelName + "---------------------------------"
        predictionError = []
        for z in range(1)  :
            iterationLength = datetime.now()
            dataMatrix = randomData(dataMatrix, 1809)
            dataMatrix = normalize(dataMatrix, 1, dataMatrix[:,-1])
            train, test = holdOut(dataMatrix, 0.7)
            trainTargets = train[:,-1].astype(float)
            testTargets = test[:,-1].astype(float)
            m = model.fit(np.delete(train, -1, 1), trainTargets)
            error = estimateError(testTargets, m.predict(np.delete(test, -1, 1)))
            print error
            predictionError.append(error)
    modelsPredictionError.append(np.array(predictionError).mean(axis = 0))

dataMatrix = loadFile("../train.csv")
models = [DecisionTreeRegressor(), AdaBoostRegressor()]
dMining(dataMatrix, models)
