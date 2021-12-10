# Boston University FALL2021 CS640 A1 Final Project - Demographic age and Race Prediction of twitter users

Team member: Yuyang Li, Weilin Liang, Lingyan Xie, Chuwei Chen, Chenyu Cao

![](https://lh4.googleusercontent.com/F3TdxG0zj_bt-W1uDJMWgPvrPBVU92OEPS9KMYDJ56eilxsxNcj_GV260lw_Cc8ettbDeBJFDH5FLVoA3r7GwLHabpEW-2OLnAruG45fgA2yiFOj8U-JTYsn027HOh-C6vR-Csqs "horizontal line")

Introduction
============

Our team uses trained two models with two different datasets to predict users' age and race. There were twitter users' profile information (user id, first name, last name, location, language, race, age, etc), profile pictures and tweets in the two given datasets. We mainly focus on text models in this project.

Approach and Analysis of Result - Race
======================================

Data preprocessing and selection:

* The dataset files Twitter_User_Handles_labeled_tweets.json, User_demo_profiles.json, and labeled_users.csv are not included in the repo for copyright reasons. If needed, please contact one of our team member.

First, we merge the data from Twitter_User_Handles_labeled_tweets.json, User_demo_profiles.json and  labeled_users.csv using user_id. Then we did a quick count at the data, and found that we have data of Whites dozens of times more than other races, but we decided to keep all data for now because if we just sample the Whites data to be as much as other races, the overall data samples would be too small and may reduce the meaning for the results. 

At last we did preprocess for both tweets and names. For tweets, we remove hashtags, @usernames, punctuations except ? and links; for names, we remove all data that contain incorrect forms of names, separate first name and last name, and  if there is only one word in name, we treat it as both the last name and the first name.

Training model: Logistic Regression with TF-IDF vectorizer + Oversampling (SMOTE)

We actually tried various models to train the data, including Linear Regression,  Logistic Regression, and SGDRegressor + GridSerchCV.  Among those models, we got our highest accuracy when using Logistic Regression with multiclass = "multinomial". It has a high overall accuracy of around 80% but most of it comes from predicting Whites and predicts no one to be Asian or Hispanic.  We think the problem is still on our dataset, and we need to deal with the imbalanced data.

Apply Oversampling

In order to equalize the quantity of all 4 races,  we used an oversampling method(SMOTE)  to process the training data and trained the model again. The results turned out well. Our model gives better performance on the accuracy for predicting African American and Hispanic people. Meanwhile, the accuracy for predicting white people is not decreasing. 

Model from ethnicolr

Based on the results for training tweets, we think it's necessary to apply a pre-trained model to our data since it's quite imbalanced to be considered good training data. We decided to use the package "ethniclor". In this package, it provides different functions which depend on three databases to predict race based on first and last name or just the last name. We use two specific functions from this package, the first one based on the full name fl model, and the second one based on the last name census 2000 model.

Results - Race
==============

![](https://lh5.googleusercontent.com/Ai2A_TBjFoTJpA4CD7NxN7swwKs-HUUOPrwMiiYmKwsOH4PwRqQJ5D5GHyt-jeVvwpTXnKTJMrL9qeeVEbUHmntO3S0aGVLVW2-n_3oQYVPhIp5kg6kuTqqCMeEQkbnhIGyOnykQ)![](https://lh6.googleusercontent.com/SUsZq9iVBFMixvjWF36miryWEsvocA9aaUAy3Rg6s1eyGsyxUYfaDao3lgQGRd59LW5g3CukUAEwxYaKfTxBqTzL9kp01S1R_LVVpa4Gdbgt4FM0UuCz_xnBA5zQiTznghFHMkvZ)

Figure 1: The results of LR before oversampling         Figure 2: The results of LR after oversampling

![](https://lh4.googleusercontent.com/DbZTM6ns-GbjKOBZyOEMqnhYMvG3KtGj9GrbuFHJowYWKS6q7K4PyrVuzLnX9Sri77wrC3M8pkqKp2Jr0G43Gt3WuqsO65nmrjszRJ-jFDx_mnu8Jpi7DkiLq6yLRI6GA4rOoH6B)![](https://lh4.googleusercontent.com/E8O4JTUCOBNw3a_HBgiCcJjP8zRalj9yQ7vMO0YhX5X1vWsYRe1j1xyWnxZ9rcVoZhwY0S2mNXRsg8DuSF0wAJQUJVDdP15z0NKvEINiOtW5_ndvGlWsgkQTo5dhqQhC04HEbB01)

Figure 3: The results of full_name pre-trained model Figure 4: The results of last_name pre-trained model

Potential cause:

Since our model always has a very low even zero accuracy when predicting race except for white, we actually took a look at the Asian names which are predicted as white, and surprisingly found that the names of Asians are like the following table. Even humans would think these are not Asian names. Therefore, it is difficult for us to get high accuracy in predicting Asians using the current dataset.

![](https://lh3.googleusercontent.com/DZ0ta9OQ5ngdzibizcEmWCVCuXKyvNDmiWbhc3M1buluM5iI9kaZTNn4CKbUSm0dFRo0O9Chm1RffDt4HudB02m8nqZRGOcy6UddfCG7DFwkNf6SGwa9uD1pzRgDmaN97gPfifaH)

Figure 5: sample Asian names

Approach and Analysis of Result - Age
=====================================

* The dataset files labeled_users.csv, tweets.json, and preprocessed file labeled_users_clean.csv are not included in the repo for copyright reasons. If needed, please contact one of our team member.

Data preprocessing and selection:

First of all, we found that the given labeled_user.csv file has many rows with missing age or just simply an empty row. Also, we noticed that some users' language is undefined which is useless and might affect our training result. Therefore, with rows that were empty or have missing values, we deleted them from the CSV file and we only selected users that speak English for our analysis since English is the only valid language label in the language column in the .csv file (another label is "undefined"). After this process, we merged the tweets and user_id and we had 980 labeled users and their tweets data out of the originally 1096 labeled users as shown in figure 6.

![](https://lh3.googleusercontent.com/cuPgzQpE7vrJuzVjNGseA6SGvXHvff0NNbbU1hnbrtstwjwI4SjqiufbEsmPtV0Xzlqdf8SPmO0m4Dox2I8DX2iywJ8XpUL0DyCU2sCWtADCPqBE-SHj59omQXs-WlK0TDHoJo-0)

Figure 6

Next, we preprocessed the tweets data. The original data, as shown in figure 7, is very messy. We decided to remove some less significant content in the tweets data. Normally we would just remove things like mentions, URLs, etc. But we also removed Punctuations, numbers, special characters, and stop words like 'a', 'is', 'the' that have a low correlation of the user's age for better accuracy. The preprocessed clean data is shown in figure 8.

![](https://lh6.googleusercontent.com/TYRb-p4qV8NSV1HRcB0UCV8MeU_5MSkOSh5St9C0hmSFfRy8wDN0m_IyrNPebfayWoRr5vwywe07-wACwvTMBSldoYlos27twbG1q6tTlB58ua2M_kMHHyAWrrydz8AOURvRM5nX)

Figure 7     Figure 8

Training model 1: Logistic Regression with TF-IDF vectorizer + Oversampling

The first model for predicting age we used was a logistic regression with TF-IDF (term frequency-inverse document frequency) vectorizer. We chose TF-IDF because TF-IDF is intended to reflect how relevant a term is in a given document. Basically, the idea behind TF-IDF is that if a word occurs multiple times in a document, it should be considered more relevant than words that appear less frequently. Also, we chose logistic regression because it could help us predict the likelihood of an event happening. By using logistic regression, we could determine the relationship between the dependent variable and one or more independent variables. Overall, we used TF-IDF to vectorize the tweets, and then we used these transformed data to perform the logistic regression. Meanwhile, we also applied techniques including oversampling and 5-fold cross-validation to augment our model. The result is shown in figure 10.

Training model 2: Complement Naive Bayes

The second model we used is Complemented Naive Bayes. As opposed to calculating the probability of an item belonging to a certain class, in complement Naive Bayes we calculate the probability of an item belonging to all classes. This is literally the meaning of complement and hence the name Complement Naive Bayes. The reason we chose it is that our data set is highly imbalanced as the number of younger users is much more than that of older users. With an unbalanced dataset, Multinomial and Gaussian Naive Bayes may produce low-accuracy models, but Complement Naive Bayes will perform quite well and provide relatively high-accuracy predictions. Therefore, we chose this model and it turned out that the performance was outstanding, reaching an accuracy of 92% as shown in figure 11. Also, Since this model performed well with imbalanced data, we didn't apply Oversampling in the training process since we wanted to keep the imbalance of the dataset.

Analysis of the results

Comparing the results, the CNB model with an accuracy of 92% had greatly outperformed the logistic regression model. We believed this was reasonable because the dataset of user's age was relatively imbalanced having a ratio of approximately 2:3 (older user : younger user) and we kept the imbalance by not applying any oversampling technique.

Results - Age
=============

Approach 1 result:

![](https://lh6.googleusercontent.com/7hrNgctujOAKw7ZqJYobsg0dpnGF-DpMvK1nWbf2qeyBtOyHqPMkumSknWylWOskZuQznrF08jJP9GK6gE2KGLyIh2TbXtvJfVgVPKtDQSqW7aQ8oQFCXxAp76o7bokNAWyOet8C)

Figure 10

Approach 2 result:

![](https://lh4.googleusercontent.com/mDAlPE6Zr4i_j_Y6cbNLoI59HDB1RlKSHlAvzJtcS4LaShnE3_aWjTZuio2jehITO8pu8w3jeXhUrdp9YhyTrmzOWaAoon6DBz5hwuiSjNgoENWY-6rOrGd0Fv3bTNFBp-pDeKfp)

Figure 11

Conclusion
==========

Almost all of our prediction models provided promising results on the given datasets. The logistic regression and ethnicolr models for race prediction could produce 81% (logistic regression), 69% (ethnicolr full name model), and 81% (ethnicolr last name census model) accuracy on the dataset. However, we still could not prove if there is any relationship between tweets and users' race since the number of users whose race is white was overwhelming. As we observed, applying SMOTE could significantly improve our model's performance on the prediction of other races. Therefore, a balanced dataset might be the key to proving the relationship between tweets styles and races. Ethnicolr models showed that there are relationships between names and races. According to this model, we also found that there were many mislabeled users in the dataset, which might lead to bad training results. Fixing the labels should be able to help improve the prediction accuracy of our models.

For the age prediction, we built a logistic regression model and a CNB model. Both models acquired outstanding accuracy on the given dataset, especially the CNB model. The logistic regression model showed a 68% accuracy without applying SMOTE (oversampling). With SMOTE, it could provide a 75% accuracy and precisions were more balanced in both cases. CNB performed a 92% accuracy on the given dataset and also had balanced precisions on both cases. The reason the CNB model outperformed might be that the distribution of users' age is imbalanced, with younger users significantly more than older users. CNB could take advantage of this kind of imbalance and provide remarkable performance. Both models showed that there should be a potential relationship between tweets and age. However, due to the imbalance of the given dataset, we could not assure this finding. To secure the finding, a larger and more balanced dataset is definitely needed.
