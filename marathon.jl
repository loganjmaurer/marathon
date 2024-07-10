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

# Plot the Kaplan-Meier curves
plt = plot(xlim=(0, maximum(df.MarathonTime)), xlabel="Marathon Time", ylabel="Survival Probability")

# Plot the curve for the cross-trained group
km_crosstraining = kaplan_meier(df.MarathonTime, df.CrossTraining .== 1)
plot!(plt, km_crosstraining, label="Cross-trained", color=:blue, alpha=0.5)
plot!(plt, km_crosstraining, ribbon=1.96 * se.(km_crosstraining), fill=:blue, alpha=0.2, label=nothing)

# Plot the curve for the non-cross-trained group
km_nocrosstraining = kaplan_meier(df.MarathonTime, df.CrossTraining .== 0)
plot!(plt, km_nocrosstraining, label="Non-cross-trained", color=:red, alpha=0.5)
plot!(plt, km_nocrosstraining, ribbon=1.96 * se.(km_nocrosstraining), fill=:red, alpha=0.2, label=nothing)

# Display the plot
display(plt)