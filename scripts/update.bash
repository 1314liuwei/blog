#!/bin/bash

# 确保目标目录存在
mkdir -p hugo/content/post
mkdir -p hugo/content/page/plan

# 首先处理 plan.md
if [ -f "docs/plan.md" ]; then
    plan_file="docs/plan.md"
    target_plan="hugo/content/page/plan/index.md"
    
    # 获取git时间
    created=$(git log --follow --format=%aI --reverse "$plan_file" | head -n 1)
    if [ -z "$created" ]; then
        created=$(date -r "$plan_file" +"%Y-%m-%dT%H:%M:%S%:z")
    fi
    
    modified=$(git log -1 --format=%aI "$plan_file")
    if [ -z "$modified" ]; then
        modified=$(date -r "$plan_file" +"%Y-%m-%dT%H:%M:%S%:z")
    fi
    
    # 创建临时文件
    temp_file=$(mktemp)
    
    # 写入新的头部信息
    cat > "$temp_file" << EOF
---
title: "Plan"
slug: "plan"
layout: "plan"
date: $created
lastmod: $modified
menu:
    main:
        name: Plan
        weight: 6
        params: 
            icon: plan
---
EOF
    
    # 追加内容
    if grep -q "^---" "$plan_file"; then
        sed -n '/^---/,/^---/!p' "$plan_file" | tail -n +2 >> "$temp_file"
    else
        cat "$plan_file" >> "$temp_file"
    fi
    
    # 移动到目标位置
    mv "$temp_file" "$target_plan"
    
    echo "处理完成: $plan_file -> $target_plan"
fi

# 处理其他 .md 文件
find docs -type f \( -name "*.md" -o -name "*.html" \) | while read -r file; do
    # 获取文件扩展名
    ext="${file##*.}"
    
    # 跳过 plan.md
    if [ "$file" = "docs/plan.md" ]; then
        continue
    fi
    
    # 获取文件名（不带扩展名）
    filename=$(basename "$file" ."$ext")
    
    # 获取上级目录名
    category=$(basename "$(dirname "$file")")
    
    # 构建目标文件路径（保持原始扩展名）
    target_dir="hugo/content/post/$category"
    target_file="$target_dir/$filename.$ext"
    
    # 创建目标目录
    mkdir -p "$target_dir"
    
    # 获取git创建时间（第一次提交时间）
    created=$(git log --follow --format=%aI --reverse "$file" | head -n 1)
    if [ -z "$created" ]; then
        created=$(date -r "$file" +"%Y-%m-%dT%H:%M:%S%:z")
    fi
    
    # 获取git最后修改时间
    modified=$(git log -1 --format=%aI "$file")
    if [ -z "$modified" ]; then
        modified=$(date -r "$file" +"%Y-%m-%dT%H:%M:%S%:z")
    fi
    
    # 创建临时文件
    temp_file=$(mktemp)
    
    # 写入新的头部信息
    cat > "$temp_file" << EOF
---
title: "$filename"
date: $created
lastmod: $modified
categories:
    - $category
---

EOF
    
    # 直接追加原文件内容
    cat "$file" >> "$temp_file"
    
    # 将临时文件移动到目标位置
    mv "$temp_file" "$target_file"
    
    echo "处理完成: $file -> $target_file"
done