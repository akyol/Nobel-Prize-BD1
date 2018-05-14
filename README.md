# Nobel-Prize-BD1
INFO 201 Group BD1's repo that will explore and gather insightful information from data about Nobel Prize recipients (and their deaths).


## Project Description

Our project will be focused on analyzing data about Nobel Prize winners
over the years. Some of the target audiences who might look at the
visualizations we create could be current scholars who are curious about
the qualities of a winner of a prize, or promoters of political justice
worldwide.

Questions that we would like to inform our audience based on this
project are:
1. The countries that are represented by the winners
2. Which professors from US universities won Nobel prizes
3. The number of prizes awarded for each category
4. The percentage breakdown of how the awards are split
5. People who passed away before being able to receive their prize

The dataset we will be utilizing will be the
[NobelPrize API](https://nobelprize.readme.io/), because it
details a lot of specific information about each recipient of these prizes.
This API was created by Nobelprize.org, the Official Website of the Nobel
Prize.


## Technical Description

- How will you be reading in your data (i.e., are you using an API, or is it a static .csv/.json file)?

We will be using various resources to read in data, including API from [NobelPrize API](https://nobelprize.readme.io/), .csv file from [Kaggle](https://www.kaggle.com/nobelfoundation/nobel-laureates/data ), and archives from [The Nobel Prize Internet Archives](http://www.almaz.com/nobel/peace/).

- What types of data-wrangling (reshaping, reformatting, etc.) will you need to do to your data?

Some of the data-wrangling we will make use of are:
1. grouping data (i.e., find the total number of winners for each country)
2. making new variables (i.e. create a boolean variable which indicates whether or not the Nobel winners received the Prize before they passes away.)
3. subsetting observations (i.e. create subsets of observations based on gender)

- What (major/new) libraries will be using in this project (no need to list common libraries that are used in many projects such as dplyr)

We will mainly use *Plotly* in data visualizations (i.e., we will use an interactive map to visualize the countries that are represented by the Nobel winners)

- What major challenges do you anticipate?
