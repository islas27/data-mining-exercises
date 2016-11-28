#importar librerias
import csv
import pandas as pd
import numpy as np

#Modelos
from sklearn.tree import DecisionTreeRegressor
from sklearn.neural_network import MLPRegressor
from sklearn.svm import SVR
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import ExtraTreesRegressor
from sklearn.ensemble import BaggingRegressor
from sklearn.ensemble import AdaBoostRegressor
from sklearn.neighbors import KNeighborsRegressor

from sklearn.metrics import mean_absolute_error

#Preprocesamiento
import matplotlib.pyplot as plt
from sklearn.grid_search import GridSearchCV

def leer_archivo(nombreArchivo):
	dt = pd.read_csv(nombreArchivo)
	return dt.values

def transformar_a_numerico(train, test):

	datos = np.concatenate((np.delete(train, -1, 1), test),axis = 0)
	dic = []
	indices = []

	#Recolectar el diccionario de datos
	for columna in range(len(datos[0])):
		if type(datos[0][columna]) == str:
			dic.append(np.unique(datos[:,columna]))
			indices.append(columna)

	#Cambiar a numerico
	for i in range(len(dic)):
		for j in range(len(dic[i])):
			train[np.where(train[:,indices[i]] == dic[i][j]), indices[i]] = j
			test[np.where(test[:,indices[i]] == dic[i][j]), indices[i]] = j

	return train, test

def datos_aleatorios(datos, semilla):
	indices = np.arange(datos.shape[0])
	np.random.seed(semilla)
	np.random.shuffle(indices)
	datos = datos[indices]

	return datos

def normalizacion(datos, tipo, loss):

	if tipo == 1:
		#Estandarizacion
		datos = datos.astype(float)
		mean = datos.mean(axis = 0)
		std = datos.std(axis = 0)
		datos = (datos - mean) / std
		datos[:,-1] = loss

	return datos

def hold_out(datos, entrenamiento):

	if entrenamiento > 1:
		entrenamiento = .70

	tamentrenamiento = len(datos) * entrenamiento

	train = datos[0:tamentrenamiento]
	test = datos[tamentrenamiento:len(datos) - 1]

	return train, test

def estimar_error(verdaderos, predichos):
	return mean_absolute_error(verdaderos, predichos)

def generar_archivo_kaggle(predichos, indices, nombreModelo, idM):

	nombreArchivo = 'sub_' + nombreModelo + '_' + str(idM) + '.csv'

	file1 = open(nombreArchivo, "w")
	file1.write("id,loss\n")
	for i in range(len(indices)):
		file1.write(str(indices[i]) + "," + "{0:.2f}".format(predichos[i]) + "\n")
	file1.close()

def sel_car_arbol(datos, targets):
	modelo = ExtraTreesRegressor()
	modelo.fit(datos, targets)

	indices = np.arange(len(modelo.feature_importances_))


	carac_2 = modelo.feature_importances_.reshape(len(modelo.feature_importances_), 1)
	ind_2 = indices.reshape(len(indices), 1)

	importancia = np.concatenate((ind_2, carac_2), axis = 1)
	importancia = importancia[importancia[:,1].argsort()]

	plt.bar(importancia[:,0], importancia[:,1], alpha = 0.5, 
		color = 'b', label = 'importancia')

	print importancia
	plt.show()

def sampling(datos, fraccion, remplazo, semilla):
	df = pd.DataFrame(datos)
	sample = df.sample(frac = fraccion, replace = remplazo, random_state = semilla)

	return sample.values

def sintonizacion(datos, modelo, par_grid, k):
	grif_s = GridSearchCV(modelo, par_grid, cv = k, verbose = 3)
	m = grif_s.fit(np.delete(datos, -1, 1), datos[:,-1])
	print "Resultados estimadores"
	print np.array(grif_s.grid_scores_)
	print "Mejor modelo " + str(grif_s.best_params_) + ": " +str(grif_s.best_score_)

	return m

def aplicacion_algoritmos(datos, modelos, testKaggle):
	errorModelos = []

	for modelo in modelos:

		nombreModelo = str(type(modelo)).split(".")[-1][:-2][:-len("Classifier")]
		print '-----------------------' + nombreModelo + '------------------------'

		errorModelo = []
		for z in range(1):#Numero iteraciones por modelo
			datos = datos_aleatorios(datos, 1809)
			datos = normalizacion(datos, 1, datos[:,-1])

			train, test = hold_out(datos, .70)

			traint = train[:,-1].astype(float)
			testt = test[:,-1].astype(float)

			m = modelo.fit(np.delete(train, -1, 1), traint)

			error = estimar_error(testt, m.predict(np.delete(test,-1,1)))
			print error
			generar_archivo_kaggle(m.predict(testKaggle), testKaggle[:,0], nombreModelo, z)

			errorModelo.append(error)
		
		errorModelos.append(np.array(errorModelo).mean(axis = 0))	

def apl_alg_sint(datos, modelos, testKaggle):
	par_grid = [{'max_features': [0.5, 1.], 'max_depth': [5., None]},
				{'max_features': [0.5, 1.], 'max_depth': [5., None]}]

	for modelo, parametros in zip(modelos, par_grid):

		nombreModelo = str(type(modelo)).split(".")[-1][:-2][:-len("Classifier")]
		print '-----------------------' + nombreModelo + '------------------------'

		datos = normalizacion(datos, 1, datos[:,-1])

		m = sintonizacion(datos, modelo, parametros, 2)

		testSamp = sampling(datos, .10, True, 1809)

		error = estimar_error(testSamp[:,-1], m.predict(np.delete(testSamp,-1,1)))
		print error
		#generar_archivo_kaggle(m.predict(testKaggle), testKaggle[:,0], nombreModelo, 0)


		

train = leer_archivo('train.csv')
testKaggle = leer_archivo('test.csv')

train, testKaggle = transformar_a_numerico(train, testKaggle)

#sel_car_arbol((np.delete(train, -1, 1)), train[:,-1])

modelos = [DecisionTreeRegressor(),
		   RandomForestRegressor()]

apl_alg_sint(train, modelos, testKaggle)		 

'''
modelos = [DecisionTreeRegressor(),
		   RandomForestRegressor(),
		   ExtraTreesRegressor(),
		   KNeighborsRegressor(),
		   BaggingRegressor(),
		   AdaBoostRegressor()]

aplicacion_algoritmos(train, modelos, testKaggle)
'''