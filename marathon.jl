using CSV, DataFrames, CoxModels

# Read in the data
df = CSV.read("MarathonData.csv", DataFrame)

# Handle the missing values in CrossTraining
df.CrossTraining = ifelse.(ismissing.(df.CrossTraining), 0, 1)

# Fit the Cox proportional hazards model
model = CoxModel(@formula(MarathonTime ~ km4week + sp4week + Wall21 + CrossTraining))
fit = fit!(model, df)

# Summary of the model
print(fit)