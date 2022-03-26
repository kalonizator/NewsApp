//
//  ArticleView.swift
//  NewsApp
//
//  Created by Yermek Sabyrzhan on 26.03.2022.
//

import SwiftUI
import URLImage

struct ArticleView: View {
    let article: Article

    var body: some View {
        HStack {
            ArticleImageView(imageURL: article.image)
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title ?? "")
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .semibold))
                Text(article.source ?? "")
                    .foregroundColor(.gray)
                    .font(.footnote)

            }
        }
    }
}

struct ArticleImageView: View {
    let imageURL: String?
    var body: some View {
        if let imageURL = imageURL,
           let url = URL(string: imageURL) {
            URLImage(url) {
                EmptyView()
            } inProgress: { progress in
                PlaceHolderView()
            } failure: { error, retry in
                PlaceHolderView()
            } content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 100, height: 100)
            .cornerRadius(10)
        } else {
            PlaceHolderView()
        }
    }
}

struct PlaceHolderView: View {
    var body: some View {
        Image(systemName: "photo.fill")
            .foregroundColor(.white)
            .background(.gray)
            .frame(width: 100, height: 100)
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: Article.dummyData)
    }
}
